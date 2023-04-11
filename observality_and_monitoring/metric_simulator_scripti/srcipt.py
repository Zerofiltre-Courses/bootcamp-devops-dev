import requests
import time

endpointread = "http://localhost:5000/articles/45"
endpointwrite = "http://localhost:5000/articles"

start_time = time.time()
end_time = start_time + 300  # 5 minutes

while time.time() < end_time:
    response1 = requests.get(endpointread)
    response2 = requests.post(endpointwrite, data={"title":"test", "content":"ok"})
    print("Response1 Status Code:", response1.status_code)
    print("Response2 Status Code:", response2.status_code)
    time.sleep(1)
