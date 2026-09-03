import urllib.request, json
url = "http://127.0.0.1:3000/api/v1/prediction/demo-agent"
data = json.dumps({"question":"Hola","sessionId":"s1"}).encode()
req = urllib.request.Request(url, data=data, headers={"Content-Type":"application/json"})
try:
    print(urllib.request.urlopen(req, timeout=10).read().decode()[:500])
except urllib.error.HTTPError as e:
    print("HTTP " + str(e.code))
    print(e.read().decode()[:500])
except Exception as e:
    print("EXC:" + repr(e))