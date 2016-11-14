#!/usr/bin/env bash

#http://unix.stackexchange.com/questions/166359/how-to-grep-the-output-of-curl
#curl -v --silent https://google.com/ 2>&1 | grep expire

echo "couch check"
#if ( curl -X GET http://127.0.0.1:5984/smile 2>&1  | grep not_found ) then
curl -X DELETE http://127.0.0.1:5984/smile 2>&1 > /dev/null
echo "couch population"
curl -X PUT http://127.0.0.1:5984/smile 2>&1 > /dev/null

curl -X PUT http://127.0.0.1:5984/smile/_design/activity --data-binary @./_design.activity.json 2>&1 > /dev/null
curl -X PUT http://127.0.0.1:5984/smile/_design/generic --data-binary @./_design.generic.json 2>&1 > /dev/null
curl -X PUT http://127.0.0.1:5984/smile/_design/group --data-binary @./_design.group.json 2>&1 > /dev/null
curl -X PUT http://127.0.0.1:5984/smile/_design/institution --data-binary @./_design.institution.json 2>&1 > /dev/null
curl -X PUT http://127.0.0.1:5984/smile/_design/resource --data-binary @./_design.resource.json 2>&1 > /dev/null
curl -X PUT http://127.0.0.1:5984/smile/_design/response --data-binary @./_design.response.json 2>&1 > /dev/null
curl -X PUT http://127.0.0.1:5984/smile/_design/session --data-binary @./_design.session.json 2>&1 > /dev/null
curl -X PUT http://127.0.0.1:5984/smile/_design/user --data-binary @./_design.user.json 2>&1 > /dev/null
curl -X PUT http://127.0.0.1:5984/smile/_design/message --data-binary @./_design.message.json 2>&1 > /dev/null
curl -X PUT http://127.0.0.1:5984/smile/_design/usage --data-binary @./_design.usage.json 2>&1 > /dev/null
curl -X PUT http://127.0.0.1:5984/smile/0eeeb110f2dcfb68d7bc63ede2002b44 --data-binary @./smileadmin.user.json 2>&1 > /dev/null
curl -X PUT http://127.0.0.1:5984/smile/0eeeb110f2dcfb68d7bc63ede2002d47 --data-binary @./welcometosmile.group.json 2>&1 > /dev/null

#fi
echo "done with couch script"
