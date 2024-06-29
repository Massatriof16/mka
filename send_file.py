from telegram import Bot
from telegram import InputFile

# Token bot Telegram
TOKEN=

# ID chat tujuan
CHAT_ID=

# Path ke file yang ingin dikirim
FILE_PATH=

# Inisialisasi bot Telegram
bot = Bot(token=TOKEN)

# Kirim file ke chat ID
with open(FILE_PATH, 'rb') as file:
    input_file = InputFile(file, filename=FILE_PATH)
    bot.send_document(chat_id=CHAT_ID, document=input_file)
