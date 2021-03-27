json.partial! 'message', message: @message

if @errors
  json.errors @errors
end
