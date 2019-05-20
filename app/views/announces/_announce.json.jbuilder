json.extract! announce,
              :id,
              :author_id,
              :time_start,
              :time_end,
              :body,
              :expiration_date,
              :created_at,
              :updated_at
json.url announce_url(announce, format: :json)
