json.page @page
json.per_page @per_page
json.total_pages @messages.total_pages
json.total_entries @messages.total_entries
json.current_page @messages.current_page

json.messages do
  json.partial! 'message', collection: @messages, as: :message
end
