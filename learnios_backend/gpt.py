import openai
import datetime
import json
from reminder import ReminderController
client = openai.OpenAI()

def get_prompt():
    return f'''
you are chatgpt api. you can only respond in json format. Since you're api, don't try to decorate text, just respond in PLAIN JSON TEXT.
you have to respond only in language that user uses.
you respond with json like: {'{'}"response": "<your response>"{'}'}
if something goes wrong while processing, add "error": "<detail>" in json.
if user wants to set reminder (they call it reminder, alarm, notification), do following.
if user requested reminder add, add "reminder_action": "add||<reminder_title>||<reminder date in yyyymmdd-hhmmss>" to json. 
    make title yourself if user didnt passed you reminder's title. you cannot raise error if user didn't specified title.
    the current time is {str(datetime.datetime.now())}.
    if user passed date based on current time(* minutes later, * hour later), calculate date based on the time i passed to you.
    if user didn't specified reminder date, add "error" in json.
    if the datetime user passed is BEFORE(PAST) the current time (the time i passed to you), add "error" in json.
if user requested reminder update, since you dont support that either, add "error" in json.
important: do not ask user twice about the reminder request. if you have insufficient information, just add "error" in json.
'''

def send_gpt(text: str):
    gpt_raw_response = client.chat.completions.create(
        model="gpt-4o",  # Or "gpt-4" if you have access
        messages=[
            {"role": "system", "content": get_prompt()},
            {"role": "user", "content": text}
        ],
    )
    gpt_response = json.loads(gpt_raw_response.choices[0].message.content.replace('```json', '').replace('```', ''))
    return_obj = { 'response': '' }
    success = False

    if 'error' in gpt_response:
        return_obj['success'] = False
        return_obj['error_detail'] = gpt_response['error']
    else:
        return_obj['success'] = True
        success = True

    if success and 'reminder_action' in gpt_response:
        action = gpt_response['reminder_action']
        print(f'[send_gpt] reminder action found: {action}')
        action_parsed = action.split('||')

        if action_parsed[0] == 'add':
            return_obj['target_reminder'] = ReminderController.add_reminder(action_parsed[1], datetime.datetime.strptime(action_parsed[2], '%Y%m%d-%H%M%S')).by_dict()
            return_obj['reminder_action'] = 'add'
    else:
        return_obj['reminder_action'] = 'none'

    if 'response' in gpt_response:
        return_obj['response'] = gpt_response['response']
    
    return return_obj