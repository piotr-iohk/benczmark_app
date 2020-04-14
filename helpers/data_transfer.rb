module Helpers
  module DataTransfer
    def insert_into_db(buildkite_data_hash, db_connection)
      res = buildkite_data_hash
      if res[:build]
        build_no = res[:build].number
        puts " Build OK, inserting..."
        id = db_connection[:nightly_builds].insert(datetime: res[:build].created_at,
                                        build_no: res[:build].number,
                                        rev: res[:build].revision)
      end

      if res[:mainnet_restores]
        puts " Inserting mainnet_restores for build: #{build_no}"
        db_connection[:mainnet_restores].insert(nightly_build_id: id,
                                     time_seq: res[:mainnet_restores].time_seq,
                                     time_1per: res[:mainnet_restores].time_1per,
                                     time_2per: res[:mainnet_restores].time_2per)
      end

      if res[:testnet_restores]
        puts " Inserting testnet_restores for build: #{build_no}"
        db_connection[:testnet_restores].insert(nightly_build_id: id,
                                     time_seq: res[:testnet_restores].time_seq,
                                     time_1per: res[:testnet_restores].time_1per,
                                     time_2per: res[:testnet_restores].time_2per)
      end
    end

    def find_builds_to_transfer(current_id, list_of_last_ids)
      list_to_return = []
        list_of_last_ids.each do |id|
          return list_to_return if current_id == id
          list_to_return << id
        end
    end
  end
end
