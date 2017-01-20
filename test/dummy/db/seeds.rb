organization1 = Organization.create! name: "Bill's bodacious organization!"
organization2 = Organization.create! name: "Ted's tubular organization!"

user1 = organization1.users.create! uuid: '1', email: "bill.s.preston@bodacious.com", first_name: "Bill S.",        last_name: "Preston"
user2 = organization2.users.create! uuid: '2', email: "ted.t.logan@tubular.com",      first_name: "Ted 'Theodore'", last_name: "Logan"
user3 = organization1.users.create! uuid: '3', email: "elizabeth@ironmaiden.com",     first_name: "Elizabeth",      last_name: "Princess"
user4 = organization2.users.create! uuid: '4', email: "joanna@ironmaiden.com",        first_name: "Joanna",         last_name: "Princess"

project1 = organization1.projects.create! name: "bogus",     uuid: '1'
project2 = organization1.projects.create! name: "excellent", uuid: '2'
project3 = organization2.projects.create! name: "rad",       uuid: '3'
project4 = organization2.projects.create! name: "station",   uuid: '4'

project1.update_attributes users: [user1]
project3.update_attributes users: [user2]

user1.api_credentials.create! access_key: "bill", password: "ilovejoanna"
user2.api_credentials.create! access_key: "ted",  password: "iloveelizabeth"