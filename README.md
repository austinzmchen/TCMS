
paginated by page size; start or end idx is variable
GET /events?limit=25&since=1364849754

Simpler:
paginated by start or end idx, page size is a variable
GET /events?start={timestamp}&end={timestamp}


1524153991
1524358800

2015-10-01T00:00:00Z
2015-10-04T00:00:00Z


**Event entity:**

```
{
	"id": "someid1",
	"title": "title1",
	"desc": "desc",
	"createdTime": "",
	"scheduledTime" 1526643000,
	"//c": "05/18/2018 @ 11:30am (UTC)",
	"duration": 3600,
	"class": {
		"instructor": [
			"Megan"
		],
		"level": 1
	}
}
```

**Events.json**

```
{
    "events": [
        {
            "id": "someid1",
            "title": "title1",
            "desc": "desc",
            "createdTime": "",
            "scheduledTime" 1526643000,
            "//c": "05/18/2018 @ 11:30am (UTC)",
            "duration": 3600,
            "class": {
            	"instructor": [
            		"Megan"
            	],
            	"level": 1
            }
        },
        {
            "id": "someid2",
            "title": "title2",
            "desc": "desc",
            "createdTime": "",
            "scheduledTime" 1524178800,
            "//c": "05/19/2018 @ 11:30pm (UTC)",
            "duration": 3600,
            "class": {
            	"instructor": [
            		"Megan"
            	],
            	"level": 1
            }
        }
    ]
}
```

**News.json**

```
{
    "feeds": [
        {
            "id": "feed1",
            "title": "",
            "desc": "",
            "createdAt": "2015-10-01T00:00:00Z",
            "images": [
            ],
            event: "someid1"
        },
        {
            "id": "feed2",
            "title": "",
            "desc": "",
            "createdAt": "",
            "images": [
            ],
            event: "someid2"
        }
    ],
    featured: [
        {
            {
            	"id": "feed1",
	            "title": "",
    	        "desc": "",
    	        "createdAt": "",
        	    "images": [
            	],
	            event: "someid1"
    	    },
            "misc": []
        }
    ]

}
```