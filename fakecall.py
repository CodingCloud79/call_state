# twilio recovery code : KB767QWP2ANYVZ2N2EUWPYT2
# +17816041536

from twilio.rest import Client
import time

# Twilio Account SID and Auth Token
account_sid = 'AC7d3048c509cf77263ed2be9df2d6a557'
auth_token = '025998628223a6ccddbb3682031b5ef2'

# Twilio phone number
from_number = 'your_twilio_phone_number'

# Phone number to call (can be any valid phone number)
to_number = 'recipient_phone_number'

# Initialize Twilio client
client = Client(account_sid, auth_token)

# Function to make the fake call
def make_fake_call():
    # Make the call
    call = client.calls.create(
        to=+919145369970,
        from_=+17816041536,
        url='http://demo.twilio.com/docs/voice.xml'  # URL for TwiML instructions (can be a simple XML response)
    )
    
    # Print call SID
    print("Starting call... ")

    # Wait for the call to complete (adjust the duration as needed)
    time.sleep(20)

    # End the call (you can also use Twilio's REST API to modify the call status)
    print("Ending fake call...")
    client.calls(call.sid).update(status='completed')

# Call the function to initiate the fake call
make_fake_call()
