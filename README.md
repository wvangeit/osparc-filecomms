oSparc File Communications Python Library
=========================================

This library is meant to perform stable file-based communications between python code that runs in oSparc services.

Installation
------------
```
pip install osparc-filecomms
```

Handshake Usage
---------------

With a handshake two services can exchange each other's ID, with a guarantee that the service on the other side is alive.
The protocol has an 'initiator' and a 'receiver'.

```
from osparc-filecomms import handshakers
import uuid

# Existing input/output directories
input_dir = Path("input_dir") 
output_dir = Path("output_dir")

my_uuid = str(uuid.uuid4())

is_initiator = True # Change this according to if you are the initiator or the receiver
handshaker = handshakers.FileHandshaker(my_uuid, input_dir, output_dir, is_initiator=is_initiator)

other_side_uuid = handshaker.shake()
print(f"I performed a handshake. My uuid is: {my_uuid}. The other side's uuid is: {other_side_uuid}")
```

After this code has run on both sides, both uuid's can be used in data files that are exchanged. 
If the processes accessing these files make sure the receiver and sender uuid match, they can be sure the files are coming from another service that is live.
For example to send a file:

```
import json

output_file_path = output_dir \ 'some_data.json'
data = [4, 3]
file_content = {
  'sender_uuid': my_uuid,
  'receiver_uuid': other_side_uuid, 
  'data': data
}
output_file_path.write_text(json.dumps(file_content))
```

The other process can the receive it then using:

```
import json

input_file_path = input_dir \ 'some_data.json'

sender_uuid = None
receiver_uuid = None
while receiver_uuid != my_uuid and sender_uuid != other_side_uuid:
  while not input_file_path.exists():
    time.sleep(1)

  file_content = json.loads(input_file_path.read_text())
  receiver_uuid = file_content['receiver_uuid']
  sender_uuid = file_content['sender_uuid']

data = file_content['data']
```
