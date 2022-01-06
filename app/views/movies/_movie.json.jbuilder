json.extract! movie, :id, :name, :string, :rating, :run_time, :created_at, :updated_at
json.url movie_url(movie, format: :json)
