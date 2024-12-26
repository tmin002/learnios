import datetime
import time
import threading

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

    def __reminder_thread(self):
        sleep_seconds = (self.date - datetime.datetime.now()).total_seconds()
        print(f'[{self}] wake after {sleep_seconds} seconds')
        if sleep_seconds > 0: 
            time.sleep(sleep_seconds)
        print(f'[{self}] woke up')
        ReminderController.remove_reminder(self.id)
        # wake up and do things


class ReminderController():
    reminders = {
        0: Reminder(0, "hello0", datetime.datetime.strptime("20301212 000000", "%Y%m%d %H%M%S")),
        1: Reminder(1, "hello1", datetime.datetime.strptime("20301212 000000", "%Y%m%d %H%M%S")),
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
