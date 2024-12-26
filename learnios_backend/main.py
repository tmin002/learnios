from fastapi import FastAPI
from pydantic import BaseModel
import gpt
import reminder
import json

app = FastAPI()

class ChatRequest(BaseModel):
    text: str

@app.post('/chat')
def send_chat(req: ChatRequest):
    return gpt.send_gpt(req.text)

@app.get('/get_reminders')
def get_reminders():
    return_obj = []
    for r in reminder.ReminderController.reminders:
        return_obj.append(reminder.ReminderController.reminders[r].by_dict())
    return {'reminders': return_obj}

@app.get('/remove_reminder')
def remove_reminder(id: int = None):
    print(f'=============== id={id}')
    target_reminder = reminder.ReminderController.reminders[id]
    reminder.ReminderController.remove_reminder(id)
    return {"removed_reminder": target_reminder.by_dict()}