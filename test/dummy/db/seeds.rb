organization1 = Organization.create! name: "Bill's bodacious organization!"
organization2 = Organization.create! name: "Ted's tubular organization!"

user1 = organization1.users.create! email: "bill.s.preston@bodacious.com",
                                    first_name: "Bill S.", last_name: "Preston",
                                    password:   "password"
user2 = organization2.users.create! email: "ted.t.logan@tubular.com",
                                    first_name: "Ted 'Theodore'", last_name: "Logan",
                                    password:   "password"
user3 = organization1.users.create! email: "elizabeth@ironmaiden.com",
                                    first_name: "Elizabeth", last_name: "Princess",
                                    password:   "password"
user4 = organization2.users.create! email: "joanna@ironmaiden.com",
                                    first_name: "Joanna", last_name: "Princess",
                                    password:   "password"

project1 = organization1.projects.create! name: "bogus"
project2 = organization1.projects.create! name: "excellent"
project3 = organization2.projects.create! name: "rad"
project4 = organization2.projects.create! name: "station"

project1.update_attributes users: [user1]
project3.update_attributes users: [user2]


user1.api_credentials.create! access_key: "bill", password: "ilovejoanna"
user2.api_credentials.create! access_key: "ted",  password: "iloveelizabeth"