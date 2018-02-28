module twitter.twitterbase;

import twitter.api;

import vibe.http.common;

/// took some inspiration from: https://github.com/alphaKAI/twitter4d
abstract class TwitterBase
{
    private static immutable API_URL = "https://api.twitter.com";

    private TwitterCredentials credentials;

    ///
    this(TwitterCredentials credentials)
    {
        this.credentials = credentials;
    }

    ///
    protected auto request(T)(string path, HTTPMethod method, string[string] params)
    {
        import std.algorithm : filter, map;
        import std.string : join;
        import std.conv : to;
        import vibe.d : requestHTTP, HTTPClientRequest, deserializeJson,
            formEncode, readAllUTF8;
        import vibe.core.log : logError, logInfo, logDebug;

        immutable url = API_URL ~ path;

        string[string] paramsObj = buildParams(params);
        paramsObj["oauth_signature"] = signature(method, url, paramsObj);

        auto authorizeKeys = paramsObj.keys.filter!q{a.startsWith("oauth_")};
        auto authorize = "OAuth " ~ authorizeKeys.map!(k => k ~ "=" ~ paramsObj[k]).join(",");

        string getPath = paramsObj.keys.map!(k => k ~ "=" ~ paramsObj[k]).join("&");

        auto res = requestHTTP(url ~ '?' ~ getPath, (scope HTTPClientRequest req) {

            req.method = method;
            // if (method == HTTPMethod.POST)
            // {
            //     req.headers["Content-Type"] = "application/x-www-form-urlencoded";
            //     req.headers["Content-Length"] = (getPath.length).to!string;
            // }
            req.headers["Authorization"] = authorize;

            //req.bodyWriter.write(getPath);
        });
        scope (exit)
        {
            res.dropBody();
        }

        if (res.statusCode == 200)
        {
            auto json = res.readJson();

            scope (failure)
            {
                logError("Response deserialize failed: %s", json);
            }

            return deserializeJson!T(json);
        }
        else
        {
            logDebug("API Error: %s", res.bodyReader.readAllUTF8());
            logError("API Error Code: %s", res.statusCode);
            throw new Exception("API Error");
        }
    }

    private string signature(HTTPMethod method, string url, string[string] params)
    {
        import std.digest.sha : SHA1;
        import std.digest.hmac : hmac;
        import std.string : representation;
        import std.algorithm : map, sort;
        import std.string : join;
        import std.base64 : Base64;

        immutable methodString = method == HTTPMethod.GET ? "GET" : "POST";

        auto query = sort(params.keys).map!(k => k ~ "=" ~ params[k]).join("&");
        auto key = [this.credentials.consumerSecret, this.credentials.accessTokenSecret].map!(
                x => encodeComponent(x)).join("&");
        auto base = [methodString, url, query].map!(x => encodeComponent(x)).join("&");
        string oauthSignature = encodeComponent(
                Base64.encode(base.representation.hmac!SHA1(key.representation)));

        return oauthSignature;
    }

    private string[string] buildParams(string[string] additionalParam = null)
    {
        import std.uuid : randomUUID;
        import std.conv : to;
        import std.datetime.systime : Clock;

        immutable now = Clock.currTime.toUnixTime.to!string;

        string[string] params = [
            "oauth_consumer_key" : this.credentials.consumerKey, //
            "oauth_nonce" : randomUUID().to!string, //
            "oauth_signature_method" : "HMAC-SHA1", //
            "oauth_timestamp" : now, //
            "oauth_token" : this.credentials.accessToken, //
            "oauth_version" : "1.0"
        ];

        if (additionalParam !is null)
        {
            foreach (key, value; additionalParam)
            {
                params[key] = value;
            }
        }

        foreach (key, value; params)
        {
            params[key] = encodeComponent(value);
        }

        return params;
    }

    private string encodeComponent(string s)
    {
        import std.regex : ctRegex, replaceAll;
        import std.uri : encodeComponentUnsafe = encodeComponent;

        char hexChar(ubyte c)
        {
            assert(c >= 0 && c <= 15);
            if (c < 10)
                return cast(char)('0' + c);
            else
                return cast(char)('A' + c - 10);
        }

        enum InvalidChar = ctRegex!`[!\*'\(\)]`;

        return s.encodeComponentUnsafe.replaceAll!((s) {
            char c = s.hit[0];
            char[3] encoded;
            encoded[0] = '%';
            encoded[1] = hexChar((c >> 4) & 0xF);
            encoded[2] = hexChar(c & 0xF);
            return encoded[].idup;
        })(InvalidChar);
    }
}
