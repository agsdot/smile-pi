curl -X DELETE http://127.0.0.1:5984/smile
curl -X PUT http://127.0.0.1:5984/smile

curl -X PUT http://127.0.0.1:5984/smile/_design/activity --data-binary @./_design.activity.json
curl -X PUT http://127.0.0.1:5984/smile/_design/generic --data-binary @./_design.generic.json
curl -X PUT http://127.0.0.1:5984/smile/_design/group --data-binary @./_design.group.json
curl -X PUT http://127.0.0.1:5984/smile/_design/institution --data-binary @./_design.institution.json
curl -X PUT http://127.0.0.1:5984/smile/_design/resource --data-binary @./_design.resource.json
curl -X PUT http://127.0.0.1:5984/smile/_design/response --data-binary @./_design.response.json
curl -X PUT http://127.0.0.1:5984/smile/_design/session --data-binary @./_design.session.json
curl -X PUT http://127.0.0.1:5984/smile/_design/user --data-binary @./_design.user.json
curl -X PUT http://127.0.0.1:5984/smile/_design/message --data-binary @./_design.message.json
