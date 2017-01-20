organization1 = Organization.create! name: "Bill's bodacious organization!"
organization2 = Organization.create! name: "Ted's tubular organization!"

user1 = organization1.users.create! uuid: SecureRandom.uuid, email: "bill.s.preston@bodacious.com", first_name: "Bill S.", last_name: "Preston"
user2 = organization2.users.create! uuid: SecureRandom.uuid, email: "ted.t.logan@tubular.com",      first_name: "Ted 'Theodore'", last_name: "Logan"

project1 = organization1.projects.create! name: "bogus", uuid: SecureRandom.uuid
project2 = organization1.projects.create! name: "excellent", uuid: SecureRandom.uuid
project3 = organization2.projects.create! name: "rad", uuid: SecureRandom.uuid
project4 = organization2.projects.create! name: "station", uuid: SecureRandom.uuid

project1.update_attributes users: [user1]
project3.update_attributes users: [user2]

user1.api_credentials.create! access_key: "bill", password: "ilovejoanna"
user2.api_credentials.create! access_key: "ted",  password: "iloveelizabeth"