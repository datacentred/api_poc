class UsageDecorator
  def initialize(organization, year, month) ; end

  def usage_data
    JSON.parse data, symbolize_names: true
  end

  private

  def data
<<-EOS
{
   "projects" : [
      {
         "name" : "wyld_stallyns",
         "id" : "3e516421b80a4b70aa816aef1dfd79fd",
         "usage" : {
            "volumes" : [
               {
                  "deleted_at" : null,
                  "name" : "excellent",
                  "latest_size_gb" : 30,
                  "usage" : [
                     {
                        "cost" : {
                           "value" : 7.05,
                           "currency" : "gbp",
                           "rate" : 0.4112
                        },
                        "unit" : "terabyte hours",
                        "meta" : {
                           "volume_type" : "Ceph SSD"
                        },
                        "value" : 17.16
                     }
                  ],
                  "id" : "7587d8b3-ddff-4ea3-b562-cf0fe2fe5864",
                  "tags" : [
                     "ssd"
                  ],
                  "created_at" : "2017-06-06T14:24:46.000+0100",
                  "owner" : "2bd21ee25cde40fdb9454954e4fbb4b5"
               }
            ],
            "vpns" : [
               {
                  "name" : "melvin",
                  "terminated_at" : "2017-06-06T16:47:47.000+0100",
                  "started_at" : "2016-12-13T15:47:46.000+0100",
                  "usage" : [
                     {
                        "value" : 137,
                        "meta" : {},
                        "unit" : "hours",
                        "cost" : {
                           "value" : 4.29,
                           "currency" : "gbp",
                           "rate" : 0.0313
                        }
                     }
                  ],
                  "owner" : "2bd21ee25cde40fdb9454954e4fbb4b5",
                  "id" : "e2c11952-1264-41a9-9b5a-529c0d227869"
               }
            ],
            "object_storage" : {
               "usage" : [
                  {
                     "unit" : "terabyte hours",
                     "value" : 0.583,
                     "cost" : {
                        "currency" : "gbp",
                        "rate" : 0.0313,
                        "value" : 0.0182
                     }
                  }
               ]
            },
            "ips" : {
               "usage" : [
                  {
                     "cost" : {
                        "value" : 3.16,
                        "rate" : 0.0027,
                        "currency" : "gbp"
                     },
                     "value" : 1170,
                     "unit" : "hours"
                  }
               ],
               "quota_changes" : [
                  {
                     "recorded_at" : "2017-06-06T15:06:55.000+0100",
                     "previous" : null,
                     "quota" : 3
                  }
               ],
               "current_quota" : 3
            },
            "load_balancers" : [
               {
                  "name" : "tubular",
                  "started_at" : "2017-06-07T09:32:28.000+0100",
                  "terminated_at" : null,
                  "usage" : [
                     {
                        "value" : 567,
                        "meta" : {},
                        "unit" : "hours",
                        "cost" : {
                           "value" : 35.15,
                           "currency" : "gbp",
                           "rate" : 0.062
                        }
                     }
                  ],
                  "owner" : "2bd21ee25cde40fdb9454954e4fbb4b5",
                  "id" : "3c7e7ddb-f5a1-4470-b2e7-3b28233e3369"
               },
               {
                  "usage" : [
                     {
                        "meta" : {},
                        "value" : 421,
                        "unit" : "hours",
                        "cost" : {
                           "value" : 26.1,
                           "currency" : "gbp",
                           "rate" : 0.062
                        }
                     }
                  ],
                  "id" : "f516b45f-9a4a-4c57-90cf-5ad9da6751cc",
                  "owner" : "2bd21ee25cde40fdb9454954e4fbb4b5",
                  "started_at" : "2017-06-13T11:06:01.000+0100",
                  "terminated_at" : null,
                  "name" : "metal"
               }
            ],
            "images" : [
               {
                  "name" : "bodacious",
                  "deleted_at" : null,
                  "usage" : [
                     {
                        "unit" : "terabyte hours",
                        "meta" : {},
                        "value" : 0.01,
                        "cost" : {
                           "value" : 0.01,
                           "rate" : 0.0313,
                           "currency" : "gbp"
                        }
                     }
                  ],
                  "owner" : "2bd21ee25cde40fdb9454954e4fbb4b5",
                  "id" : "72d6058a-ce79-4556-8adb-b669cadeea07",
                  "created_at" : "2017-06-06T14:26:38.000+0100",
                  "latest_size_gb" : 0.01
               },
               {
                  "created_at" : "2017-06-07T16:23:06.000+0100",
                  "owner" : "2bd21ee25cde40fdb9454954e4fbb4b5",
                  "usage" : [
                     {
                        "cost" : {
                           "value" : 0.02,
                           "currency" : "gbp",
                           "rate" : 0.0313
                        },
                        "meta" : {},
                        "unit" : "terabyte hours",
                        "value" : 0.48
                     }
                  ],
                  "id" : "f61ea97c-dd83-4a5b-90d7-a1f151d7120e",
                  "latest_size_gb" : 0.88,
                  "name" : "non-heinous",
                  "deleted_at" : null
               }
            ],
            "instances" : [
               {
                  "name" : "awesome",
                  "usage" : [
                     {
                        "meta" : {
                           "flavor" : {
                              "ram_mb" : 2048,
                              "name" : "dc1.1x2",
                              "root_disk_gb" : 40,
                              "id" : "b671216b-1c68-4765-b752-0e8e6b6d015f",
                              "vcpus_count" : 1
                           }
                        },
                        "value" : 586,
                        "unit" : "hours",
                        "cost" : {
                           "value" : 20.39,
                           "rate" : 0.0348,
                           "currency" : "gbp"
                        }
                     }
                  ],
                  "tags" : [],
                  "id" : "634771ce-3961-4b7c-a3e1-92da9f7bb4ed",
                  "current_flavor" : {
                     "ram_mb" : 2048,
                     "name" : "dc1.1x2",
                     "root_disk_gb" : 40,
                     "id" : "b671216b-1c68-4765-b752-0e8e6b6d015f",
                     "vcpus_count" : 1
                  },
                  "history" : [
                     {
                        "billable" : false,
                        "state" : "building",
                        "user_id" : "2bd21ee25cde40fdb9454954e4fbb4b5",
                        "recorded_at" : "2017-06-06T14:31:59.000+0100",
                        "flavor" : "b671216b-1c68-4765-b752-0e8e6b6d015f",
                        "seconds" : 7,
                        "event_name" : "compute.instance.create.start"
                     },
                     {
                        "billable" : true,
                        "state" : "active",
                        "user_id" : "2bd21ee25cde40fdb9454954e4fbb4b5",
                        "flavor" : "b671216b-1c68-4765-b752-0e8e6b6d015f",
                        "recorded_at" : "2017-06-06T14:32:05.000+0100",
                        "seconds" : 2107675,
                        "event_name" : "compute.instance.create.end"
                     }
                  ],
                  "terminated_at" : null,
                  "first_booted_at" : "2017-06-06T14:32:05.000+0100",
                  "latest_state" : "active"
               },
               {
                  "name" : "bogus",
                  "usage" : [
                     {
                        "meta" : {
                           "flavor" : {
                              "root_disk_gb" : 80,
                              "id" : "9cf6e43b-e191-47ca-8665-f8592e2d6227",
                              "vcpus_count" : 4,
                              "ram_mb" : 8192,
                              "name" : "dc1.4x8"
                           }
                        },
                        "unit" : "hours",
                        "value" : 586,
                        "cost" : {
                           "rate" : 0.1391,
                           "currency" : "gbp",
                           "value" : 81.51
                        }
                     }
                  ],
                  "tags" : [],
                  "id" : "e62c16d2-950f-4bec-bea7-e21edd330500",
                  "history" : [
                     {
                        "state" : "building",
                        "billable" : false,
                        "user_id" : "2bd21ee25cde40fdb9454954e4fbb4b5",
                        "recorded_at" : "2017-06-06T14:23:59.000+0100",
                        "flavor" : "9cf6e43b-e191-47ca-8665-f8592e2d6227",
                        "seconds" : 23,
                        "event_name" : "compute.instance.create.start"
                     },
                     {
                        "recorded_at" : "2017-06-06T14:24:21.000+0100",
                        "flavor" : "9cf6e43b-e191-47ca-8665-f8592e2d6227",
                        "event_name" : "compute.instance.create.end",
                        "seconds" : 2108139,
                        "state" : "active",
                        "billable" : true,
                        "user_id" : "2bd21ee25cde40fdb9454954e4fbb4b5"
                     }
                  ],
                  "current_flavor" : {
                     "vcpus_count" : 4,
                     "root_disk_gb" : 80,
                     "id" : "9cf6e43b-e191-47ca-8665-f8592e2d6227",
                     "ram_mb" : 8192,
                     "name" : "dc1.4x8"
                  },
                  "latest_state" : "active",
                  "first_booted_at" : "2017-06-06T14:24:21.000+0100",
                  "terminated_at" : null
               }
            ]
         }
      }
   ],
   "last_updated_at" : "2017-07-12T10:46:54Z"
}
EOS
  end
end
