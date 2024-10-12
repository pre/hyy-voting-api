class CastVote
  # Use class method `submit`
  private :initialize

  # Create a row in ImmutableVote and mark Voter's `VotingRight` as used
  # inside a single transaction. Access to `voting_rights` is exclusively
  # locked until the transaction has completed.
  #
  # Returns true IFF both VotingRight and ImmutableVote have been updated.
  # Return false or nil otherwise.
  def self.submit(election:, voter:, candidate:)
    ActiveRecord::Base.transaction do
      begin
        # Acquire a table level lock to table `voting_rights`.
        # Prevent a race condition where two simultaneous transactions
        # both see voting_right.used? in isolation and can both update it.
        #
        # A table level lock prevents any other transaction from reading the
        # value `voting_rights.used` until changes in both `VotingRight` and
        # `ImmutableVote` have been persisted.
        #
        # In PostgreSQL, only an `ACCESS EXCLUSIVE` lock blocks a `SELECT`
        # (without `FOR UPDATE/SHARE`) statement. Row-level locks do not affect
        # data querying; they block only writers to the same row.
        # https://www.postgresql.org/docs/9.1/static/explicit-locking.html
        ActiveRecord::Base.connection.execute(
          "LOCK TABLE #{VotingRight.table_name} IN ACCESS EXCLUSIVE MODE"
        )

        # Refresh inside ACCESS EXCLUSIVE to make sure nobody changed the
        # attributes while we were waiting for our lock.
        voter.voting_right.reload

        return false if voter.voting_right.used?

        voter.voting_right.update! used: true
        ImmutableVote.create! election: election,
                              candidate: candidate

        AfterVoteMailer.thank(voter).deliver_later if voter.email

        return true
      # Rollback any Exception in order to guarantee that no partial
      # update was persisted.
      rescue Exception => e
        Rails.logger.error "[CastVote] Error: #{e}"
        raise ActiveRecord::Rollback
      end
    end
  end
end
