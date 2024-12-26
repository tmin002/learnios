import datetime
import time
import threading
from reminder import Reminder

class ReminderController():
    reminders = {
        0: Reminder(0, "hello0", datetime.datetime.now),
        1: Reminder(1, "hello1", datetime.datetime.now),
                 }
    __add_request_cnt = 0

    @staticmethod
    def add_reminder(title: str, date: datetime):
        reminder = Reminder(ReminderController.__add_request_cnt, title, date) 
        ReminderController.reminders[reminder.id] = reminder
        ReminderController.__add_request_cnt += 1
        return reminder

    @staticmethod
    def remove_reminder(id):
        if id in ReminderController.reminders:
            del ReminderController.reminders[id]