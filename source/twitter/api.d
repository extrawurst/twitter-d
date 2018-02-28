module twitter.api;

import vibe.data.json;

///
struct TwitterCredentials
{
    ///
    string consumerKey;
    ///
    string consumerSecret;
    ///
    string accessToken;
    ///
    string accessTokenSecret;
}

///
struct TwitterUser
{
    ///
    bool verified;
    ///
    @optional string profile_background_image_url;
    ///
    string created_at;
    ///
    bool protected_;
    ///
    bool profile_background_tile;
    ///
    @optional bool live_following;
    ///
    bool following;
    ///
    long favourites_count;
    ///
    long id;
    ///
    bool notifications;
    ///
    bool contributors_enabled;
    ///
    long friends_count;
    ///
    string lang;
    ///
    string screen_name;
    ///
    string name;
    ///
    long followers_count;
    ///
    @optional string url;

    // is_translation_enabled":false,
    // profile_banner_url":"https://pbs.twimg.com/profile_banners/2985037894/1519517845",
    // profile_use_background_image":true,
    // utc_offset":null,
    // is_translator":false,
    // profile_background_color":"1A1B1F",
    // profile_text_color":"000000",
    // default_profile":false,
    // location":"Lake Arrowhead, CA - USA",
    // time_zone":null,
    // translator_type":"none",
    // profile_background_image_url_https":"https://pbs.twimg.com/profile_background_images/610926403563859970/IW0XUTqt.jpg",
    // statuses_count":5736,
    // follow_request_sent":false,
    // muting":false,
    // has_extended_profile":false,
    // profile_sidebar_fill_color":"000000",
    // profile_link_color":"1B95E0",
    // profile_sidebar_border_color":"000000",
    // default_profile_image":false,
    // geo_enabled":true,
    // description":"Directory - helping you make the most of your stay in Lake Arrowhead, California. Promos & Coupons. Breaking News. info@LakeArrowhead.us http://LakeArrowhead.us",
    // profile_image_url_https":"https://pbs.twimg.com/profile_images/967552520561213440/K1YyT64q_normal.jpg",
    // listed_count":437,
    // blocking":false,
    // blocked_by":false,
    // id_str":"2985037894",
    // profile_image_url":"http://pbs.twimg.com/profile_images/967552520561213440/K1YyT64q_normal.jpg"
}

///
struct FollowersList
{
    ///
    string previous_cursor_str;
    ///
    string next_cursor_str;
    ///
    long previous_cursor;
    ///
    long next_cursor;
    ///
    TwitterUser[] users;
}

///
struct Status
{
    ///
    TwitterUser user;
    ///
    bool truncated;
    ///
    bool is_quote_status;
    ///
    string text;
    ///
    string id_str;
    ///
    string created_at;
    ///
    string lang;
    ///
    long retweet_count;
    ///
    long id;
    ///
    bool retweeted;
    ///
    bool favorited;
}

///
interface TwitterAPI
{
    ///
    FollowersList followers(string screen_name, long cursor = -1,
            bool skip_status = true, bool include_user_entities = false);

    ///
    Status status(string status);

    ///
    Status statusShow(long id);
}
