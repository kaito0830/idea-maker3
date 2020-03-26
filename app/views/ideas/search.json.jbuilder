json.array! @ideas do |idea|
  json.id idea.id
  json.title idea.title
  json.info idea.info
  json.price idea.price
  json.user_id idea.user_id 
end