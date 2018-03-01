module twitter.twitter;

import twitter.api;
import twitter.twitterbase;

import std.conv : to;
import vibe.data.json : Json;
import vibe.http.common : HTTPMethod;

///
class Twitter : TwitterBase, TwitterAPI
{
    ///
    this(TwitterCredentials credentials)
    {
        super(credentials);
    }

    ///
    FollowersList followers(string screen_name, long cursor = -1,
            bool skip_status = true, bool include_user_entities = false)
    {
        static immutable METHOD_URL = "/1.1/followers/list.json";

        string[string] params;
        params["screen_name"] = screen_name;
        params["cursor"] = cursor.to!string;
        params["skip_status"] = skip_status.to!string;
        params["include_user_entities"] = include_user_entities.to!string;

        return this.request!(FollowersList)(METHOD_URL, HTTPMethod.GET, params);
    }

    ///
    IdsList friendsIds(string screen_name, long cursor = -1)
    {
        static immutable METHOD_URL = "/1.1/friends/ids.json";

        string[string] params;
        params["screen_name"] = screen_name;
        params["cursor"] = cursor.to!string;

        return this.request!(IdsList)(METHOD_URL, HTTPMethod.GET, params);
    }

    ///
    Json appRateLimitStatus()
    {
        static immutable METHOD_URL = "/1.1/application/rate_limit_status.json";

        string[string] params;

        return this.request!(Json)(METHOD_URL, HTTPMethod.GET, params);
    }

    ///
    Status status(string status)
    {
        static immutable METHOD_URL = "/1.1/statuses/update.json";

        string[string] params;
        params["status"] = status;

        return this.request!(Status)(METHOD_URL, HTTPMethod.POST, params);
    }

    ///
    Status statusShow(long id)
    {
        static immutable METHOD_URL = "/1.1/statuses/show.json";

        string[string] params;
        params["id"] = id.to!string;

        return this.request!(Status)(METHOD_URL, HTTPMethod.GET, params);
    }

    ///
    SearchResult searchTweets(string q, string lang = null, int count = 15)
    {
        static immutable METHOD_URL = "/1.1/search/tweets.json";

        string[string] params;
        params["q"] = q;
        params["count"] = count.to!string;
        if (lang)
            params["lang"] = lang;

        return this.request!(SearchResult)(METHOD_URL, HTTPMethod.GET, params);
    }

    ///
    TwitterUser friendshipsCreate(ulong user_id)
    {
        static immutable METHOD_URL = "/1.1/friendships/create.json";

        string[string] params;
        params["user_id"] = user_id.to!string;

        return this.request!(TwitterUser)(METHOD_URL, HTTPMethod.POST, params);
    }

    ///
    TwitterUser friendshipsDestroy(ulong user_id)
    {
        static immutable METHOD_URL = "/1.1/friendships/destroy.json";

        string[string] params;
        params["user_id"] = user_id.to!string;

        return this.request!(TwitterUser)(METHOD_URL, HTTPMethod.POST, params);
    }
}
