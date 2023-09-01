# OpenSeaTestNetNFTs

## List NFTs Feature Specs

## Story: User request to see the NFTs of a specific wallet address on a specific chain

### Type#1

```
As an online user
I want the app to show the NFTs list
So I can see the NFTs in my wallet address
```

#### Acceptance criteria

```
Given the user has connectivity
When the user requests to see the NFTs list
Then the app should display the NFTs name and their image
```

## Use Cases

### Load NTFs from remote use case

#### Data:
- URL
- Wallet Address
- Chain
- Next
- Limit

#### Primary path:
1. Execute "Load NFTs" command.
2. System download data from the URL.
3. System validate downloaded data.
4. System create NFT list from valid data.
5. System delivers NFT list

#### Invalid data error path:
1. System delivers invalid data error.

#### No connectivity error path:
1. System delivers connectivity error.

---

## Model Specs

### NFTInfo

| property    | type   |
|-------------|--------|
| identifier  | String |
| collection  | String |
| contract    | String |
| name        | String |
| description | String |
| image_url   | String |

### Payload contract

```
https://testnets-api.opensea.io/v2/chain/goerli/account/0x85fD692D2a075908079261F5E351e7fE0267dB02/nfts?limit=20' \
     --header 'accept: application/json'

GET 

200 RESPONSE

{
  "nfts": [
    {
      "identifier": "4",
      "collection": "bloctoassignment-v2",
      "contract": "0xc852e1a0be505e2cb925698ad1934424d11a3468",
      "token_standard": "erc721",
      "name": "Cart",
      "description": "Blocto assignment second collection",
      "image_url": "https://i.seadn.io/gcs/files/2dd62036db81799440186588caacff79.png?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmWK4nupu7h2JN36eGJyhoueSxCJrvmkpmQCuogEJELaFH/4",
      "created_at": "2022-12-07T10:22:08.979123",
      "updated_at": "2023-08-29T07:23:34.578822",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "11",
      "collection": "bloctoassignment-v2",
      "contract": "0xc852e1a0be505e2cb925698ad1934424d11a3468",
      "token_standard": "erc721",
      "name": "Smaile",
      "description": "Blocto assignment second collection",
      "image_url": "https://i.seadn.io/gae/cpGrf9zxLbi4zLVC-4bA0jTSx0oZdWCvFLW375KDowJVj0pxiqRHGcSEqR0JymR9PYxHjztlII9CGz7xQVfH2oBNZhTiFPAeZcWHGR0?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmWK4nupu7h2JN36eGJyhoueSxCJrvmkpmQCuogEJELaFH/11",
      "created_at": "2022-12-07T10:22:07.737203",
      "updated_at": "2022-12-07T10:22:10.961626",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "12",
      "collection": "bloctoassignment-v2",
      "contract": "0xc852e1a0be505e2cb925698ad1934424d11a3468",
      "token_standard": "erc721",
      "name": "Support",
      "description": "Blocto assignment second collection",
      "image_url": "https://i.seadn.io/gae/FJoy6BJ9WpWkZ5NdESD0T53PjMRcJoi6luIHoU1m_mkDGbszcVQ2J1M_7gzKkFmJxXGUPQ0tVrgv8JV_tGw4Ta8XMsNiXyir66vBDw?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmWK4nupu7h2JN36eGJyhoueSxCJrvmkpmQCuogEJELaFH/12",
      "created_at": "2022-12-07T10:22:07.736490",
      "updated_at": "2022-12-07T10:22:10.945617",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "8",
      "collection": "bloctoassignment-v2",
      "contract": "0xc852e1a0be505e2cb925698ad1934424d11a3468",
      "token_standard": "erc721",
      "name": "Logout",
      "description": "Blocto assignment second collection",
      "image_url": "https://i.seadn.io/gae/MiQOL92rfcHkafwgGAN8Ak9aQGOTlGVkKhPOPM4Ln-encjnpjHviXkOdJ97dFKNdqTQv_ENimd3oM7BLrJDU24KOvGtZ4EdwhjKN?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmWK4nupu7h2JN36eGJyhoueSxCJrvmkpmQCuogEJELaFH/8",
      "created_at": "2022-12-07T10:22:07.735248",
      "updated_at": "2022-12-07T10:22:12.812492",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "6",
      "collection": "bloctoassignment-v2",
      "contract": "0xc852e1a0be505e2cb925698ad1934424d11a3468",
      "token_standard": "erc721",
      "name": "File",
      "description": "Blocto assignment second collection",
      "image_url": "https://i.seadn.io/gae/pfF_XRWze_lAoUVar6NBaJLMlgsefZHhOSllmWIhQYNVSFxCEMS_lkK0RQysrS6u_zjfeuff0Pfdlx4G3cG13S4aTRh5U_hz6V7BFw?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmWK4nupu7h2JN36eGJyhoueSxCJrvmkpmQCuogEJELaFH/6",
      "created_at": "2022-12-07T10:22:07.734887",
      "updated_at": "2022-12-07T10:22:10.669214",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "7",
      "collection": "bloctoassignment-v2",
      "contract": "0xc852e1a0be505e2cb925698ad1934424d11a3468",
      "token_standard": "erc721",
      "name": "History",
      "description": "Blocto assignment second collection",
      "image_url": "https://i.seadn.io/gae/yXkkMjUGtBoVJr9jFa2kDNHyijHQSmUFvLCHSrmqLLz2EFl7QsBV6b50eYydIQgULGPdrW9cAsFVxjakyqNBQqQlaiXz3hkkx7nJxA?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmWK4nupu7h2JN36eGJyhoueSxCJrvmkpmQCuogEJELaFH/7",
      "created_at": "2022-12-07T10:22:07.732676",
      "updated_at": "2022-12-07T10:22:11.003996",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "3",
      "collection": "bloctoassignment-v2",
      "contract": "0xc852e1a0be505e2cb925698ad1934424d11a3468",
      "token_standard": "erc721",
      "name": "Calendar",
      "description": "Blocto assignment second collection",
      "image_url": "https://i.seadn.io/gae/V3jH-Vg3EEYRym_marbjRUWl-KyKgFxWI27eMB15NxGOopmw1TPpzDjarkQs2G-vucSspAHzWonHvnH0uWh8Fxd7xq9Tw-gmYPg-wKs?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmWK4nupu7h2JN36eGJyhoueSxCJrvmkpmQCuogEJELaFH/3",
      "created_at": "2022-12-07T10:22:07.731674",
      "updated_at": "2022-12-07T10:22:09.433703",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "9",
      "collection": "bloctoassignment-v2",
      "contract": "0xc852e1a0be505e2cb925698ad1934424d11a3468",
      "token_standard": "erc721",
      "name": "Revoke",
      "description": "Blocto assignment second collection",
      "image_url": "https://i.seadn.io/gae/KhPXLqve5eFV_fmM-oc4kNc_FXH0b_yJUvE2Jc6FhFnNSwbMmksmuMnRwLEBtiHhAIkp7RjgCS6udEqooueio8lR23eZWBdjaK3o9Fg?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmWK4nupu7h2JN36eGJyhoueSxCJrvmkpmQCuogEJELaFH/9",
      "created_at": "2022-12-07T10:22:07.730969",
      "updated_at": "2022-12-07T10:22:11.726363",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "1",
      "collection": "bloctoassignment-v2",
      "contract": "0xc852e1a0be505e2cb925698ad1934424d11a3468",
      "token_standard": "erc721",
      "name": "Addressbook",
      "description": "Blocto assignment second collection",
      "image_url": "https://i.seadn.io/gae/qfLAiT_Qrl_2CQODPRLJNxQGmW3gkmjyuprfB6W8Q2TKZ_EAUTupkfnSO_TzRuc0Cs0GW1d0OvidpCGv8j80qq_rhT7kXu-iSNzHmHE?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmWK4nupu7h2JN36eGJyhoueSxCJrvmkpmQCuogEJELaFH/1",
      "created_at": "2022-12-07T10:22:07.726843",
      "updated_at": "2022-12-07T10:22:09.385914",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "10",
      "collection": "bloctoassignment-v2",
      "contract": "0xc852e1a0be505e2cb925698ad1934424d11a3468",
      "token_standard": "erc721",
      "name": "Sell",
      "description": "Blocto assignment second collection",
      "image_url": "https://i.seadn.io/gae/p-7sEWxn27q9UFPUYyTJS230ixpygp_H6_eJk2g-SbuEdyZSfQjd4c9a-bJUriUP7Yuq6KFMwK6SaGEMsKMwedS2QE5swj8oEuI_?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmWK4nupu7h2JN36eGJyhoueSxCJrvmkpmQCuogEJELaFH/10",
      "created_at": "2022-12-07T10:22:07.611064",
      "updated_at": "2022-12-07T10:22:09.231712",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "0",
      "collection": "bloctoassignment-v2",
      "contract": "0xc852e1a0be505e2cb925698ad1934424d11a3468",
      "token_standard": "erc721",
      "name": "Accelerate",
      "description": "Blocto assignment second collection",
      "image_url": "https://i.seadn.io/gae/pi3_nQ0QJUFDpUFwU9wyB8zKAo0U_t4ngs9_XGeVeBwwdxTejsJwt5JUDipGcB8mCCpXzvAbbAL48skcM4jerqfny_p1rCbWuuf_MQ?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmWK4nupu7h2JN36eGJyhoueSxCJrvmkpmQCuogEJELaFH/0",
      "created_at": "2022-12-07T10:22:07.583827",
      "updated_at": "2022-12-07T10:22:09.890949",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "2",
      "collection": "bloctoassignment-v2",
      "contract": "0xc852e1a0be505e2cb925698ad1934424d11a3468",
      "token_standard": "erc721",
      "name": "Announcement",
      "description": "Blocto assignment second collection",
      "image_url": "https://i.seadn.io/gae/4Ie5TSOo4UQRcA4xNvdE5YNTgEvDCGGkgVjz90lHBve2OvsMVbt7r6vCkYa5G1PPJTAeJqQcYQSXGJxJ8ODN-RBPQIIh7ehCAu4_kQ?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmWK4nupu7h2JN36eGJyhoueSxCJrvmkpmQCuogEJELaFH/2",
      "created_at": "2022-12-07T10:22:07.554814",
      "updated_at": "2022-12-07T10:22:09.583242",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "13",
      "collection": "bloctoassignment-v2",
      "contract": "0xc852e1a0be505e2cb925698ad1934424d11a3468",
      "token_standard": "erc721",
      "name": "Tool",
      "description": "Blocto assignment second collection",
      "image_url": "https://i.seadn.io/gae/dOoFB6PVDsv8xqmIbiyz-udbaGB_Lfk8OhJT07A1wLaxka_lX46XsqnnHTA6fVyuiAI1RJ66gqZHFe0Uv7CZdln1bJkSIeYKseUpXA?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmWK4nupu7h2JN36eGJyhoueSxCJrvmkpmQCuogEJELaFH/13",
      "created_at": "2022-12-07T10:22:07.526554",
      "updated_at": "2022-12-07T10:22:08.912948",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "5",
      "collection": "bloctoassignment-v2",
      "contract": "0xc852e1a0be505e2cb925698ad1934424d11a3468",
      "token_standard": "erc721",
      "name": "Docs",
      "description": "Blocto assignment second collection",
      "image_url": "https://i.seadn.io/gae/_-FnthkYZuLqhaBsZxp0xqhGDPfR5nkwNmQnUq_nIoob1ox33qYHdeP7guh5byPEDd724_i8HbS1UvdyXWEb71Z-bSRA6ziTwkrAdw?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmWK4nupu7h2JN36eGJyhoueSxCJrvmkpmQCuogEJELaFH/5",
      "created_at": "2022-12-07T10:22:07.495695",
      "updated_at": "2022-12-07T10:22:12.418107",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "16",
      "collection": "bloctoassignment",
      "contract": "0xf37a02f497e21be9f4dd9a34c01568ac21578d1a",
      "token_standard": "erc721",
      "name": "Loading",
      "description": "Blocto assignment",
      "image_url": "https://i.seadn.io/gae/ayvUbxBsw30iHMZnyysqJBoqUqCh9wWdTss0xVZx1Blfg9OFRCfIR7LEPnGoHsASSh-TWhQf9liAx7r_q7efdlcCqaLfKdqRQusH?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmZHvscH2h5dXFHHvVCedreFDBEfFDWAQxsMjJTBiiKuZi/16",
      "created_at": "2022-12-07T09:12:39.636084",
      "updated_at": "2022-12-07T09:12:44.845690",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "27",
      "collection": "bloctoassignment",
      "contract": "0xf37a02f497e21be9f4dd9a34c01568ac21578d1a",
      "token_standard": "erc721",
      "name": "blt",
      "description": "Blocto assignment",
      "image_url": "https://i.seadn.io/gae/wcMDU5qxGLxL704lBz69BaBBHv70DGIypIMN3ISwRteiU8uidoMYaCq3RPbDT5hE7JOL0YvF8txRoJrH2ssPyUZQYUMI8c6NoV9EQw?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmZHvscH2h5dXFHHvVCedreFDBEfFDWAQxsMjJTBiiKuZi/27",
      "created_at": "2022-12-07T09:12:39.620881",
      "updated_at": "2022-12-07T09:12:45.057446",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "24",
      "collection": "bloctoassignment",
      "contract": "0xf37a02f497e21be9f4dd9a34c01568ac21578d1a",
      "token_standard": "erc721",
      "name": "Twitter",
      "description": "Blocto assignment",
      "image_url": "https://i.seadn.io/gae/hA0o_VlgAY6NOig9vxGzL1bmDoSm-3Qu_qdku0kyR_Q3Mqgbj6nTecFnX8mC31aK8vWWLw2-3l4TXOKx7pclXG_SKyVG8Eyk2nZ0Tg?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmZHvscH2h5dXFHHvVCedreFDBEfFDWAQxsMjJTBiiKuZi/24",
      "created_at": "2022-12-07T09:12:39.619874",
      "updated_at": "2022-12-07T09:12:43.486767",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "28",
      "collection": "bloctoassignment",
      "contract": "0xf37a02f497e21be9f4dd9a34c01568ac21578d1a",
      "token_standard": "erc721",
      "name": "medium",
      "description": "Blocto assignment",
      "image_url": "https://i.seadn.io/gae/nIUxPEKnWVgwiAZzg0Cj4BJHHCRNUdKDNkUtA3kZmET2f1KiV9feTYrXBZ9icsWUL-jsp6IiFi7C92kFz3ok-StaR87uJQXv9yeBGA?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmZHvscH2h5dXFHHvVCedreFDBEfFDWAQxsMjJTBiiKuZi/28",
      "created_at": "2022-12-07T09:12:39.618979",
      "updated_at": "2022-12-07T09:12:42.940143",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "23",
      "collection": "bloctoassignment",
      "contract": "0xf37a02f497e21be9f4dd9a34c01568ac21578d1a",
      "token_standard": "erc721",
      "name": "Treasure",
      "description": "Blocto assignment",
      "image_url": "https://i.seadn.io/gae/RdOJMsTOgxYoP3hJThePr2dmj5yTXZcnm_6SRj0_ET5YAyCLIo-kB00G3sJcy7gop23RHttKiEOhQ7cLh-b9HVT-V-UmXx_2OVtWYw?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmZHvscH2h5dXFHHvVCedreFDBEfFDWAQxsMjJTBiiKuZi/23",
      "created_at": "2022-12-07T09:12:39.618483",
      "updated_at": "2022-12-07T09:12:43.411097",
      "is_disabled": false,
      "is_nsfw": false
    },
    {
      "identifier": "21",
      "collection": "bloctoassignment",
      "contract": "0xf37a02f497e21be9f4dd9a34c01568ac21578d1a",
      "token_standard": "erc721",
      "name": "Sent",
      "description": "Blocto assignment",
      "image_url": "https://i.seadn.io/gae/h54yDBUCLtmcok3o6j4QoKF-vc3hfQfDe8hdyADiJdD4xsWzsxIpFHIXjx7NlKcUY7k2ElIOXZ67FBbIiexXFPW100RRByKm006Z?w=500&auto=format",
      "metadata_url": "https://ipfs.io/ipfs/QmZHvscH2h5dXFHHvVCedreFDBEfFDWAQxsMjJTBiiKuZi/21",
      "created_at": "2022-12-07T09:12:39.618047",
      "updated_at": "2022-12-07T09:12:43.745576",
      "is_disabled": false,
      "is_nsfw": false
    }
  ],
  "next": "LXBrPTE2MDQzMTczNQ=="
}
```

