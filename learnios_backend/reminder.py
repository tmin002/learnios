import datetime
import time
import threading

class ReminderController():
    reminders = {}
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

class Reminder():
    def __init__(self, id: int, title :str, date: datetime):
        self.id = id
        self.title = title
        self.date = date
        self.thread = threading.Thread(target = self.__reminder_thread)
        self.thread.start()
    
    def __str__(self):
        return f"(id={self.id}, title={self.title}, date={datetime.datetime.strftime(self.date, "%Y%m%d-%H%M%S")})"
    
    def by_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'date': datetime.datetime.strftime(self.date, "%Y%m%d-%H%M%S")
        }

    def __reminder_thread(target_reminder):
        sleep_seconds = (target_reminder.date - datetime.datetime.now()).total_seconds()
        print(f'[{target_reminder}] wake after {sleep_seconds} seconds')
        if sleep_seconds > 0: 
            time.sleep(sleep_seconds)
        print(f'[{target_reminder}] woke up')
        ReminderController.remove_reminder(target_reminder.id)
        # wake up and do things