const badgeUrl = 'http://localhost:8080/';

module.exports = {
    badges: {
        "90_days": {
            "name": "90 Day Staker",
            "description": "You staked your SNX for at least 90 days.",
            "external_url": badgeUrl + "90_days",
            "image": badgeUrl + "fighters/fighter-0-50-50.png",
            "attributes": [
                {
                    "trait_type": "Days Staked",
                    "value": 90,
                    "max_value": 365
                },
            ],
        },
        "180_days": {
            "name": "180 Day Staker",
            "description": "You staked your SNX for at least 180 days.",
            "external_url": badgeUrl + "180_days",
            "image": badgeUrl + "fighters/fighter-0-50-0.png",
            "attributes": [
                {
                    "trait_type": "Days Staked",
                    "value": 180,
                    "max_value": 365
                },
            ],
        },
        "365_days": {
            "name": "365 Day Staker",
            "description": "You staked your SNX for at least 365 days.",
            "external_url": badgeUrl + "365_days",
            "image": badgeUrl + "fighters/fighter-0-90-0.png",
            "attributes": [
                {
                    "trait_type": "Days Staked",
                    "value": 365,
                    "max_value": 365
                },
            ],
        },
        "top_100": {
            "name": "Top 100 Holder",
            "description": "You have one of the top 100 bags in SNX.",
            "external_url": badgeUrl + "top_100",
            "image": badgeUrl + "fighters/fighter-90-50-0.png",
            "attributes": [
                {
                    "trait_type": "Days Staked",
                    "value": 365,
                    "max_value": 365
                },
            ],
        },
        "top_1000": {
            "name": "Top 1000 Holder",
            "description": "You have one of the top 1000 bags in SNX.",
            "external_url": badgeUrl + "top_1000",
            "image": badgeUrl + "fighters/fighter-0-0-90.png",
            "attributes": [
                {
                    "trait_type": "Days Staked",
                    "value": 365,
                    "max_value": 365
                },
            ],
        }
    }
};
