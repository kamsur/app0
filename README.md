# app0

LAZARUS app project. A cross-platform Flutter based mobile application that uses alternative solutions (some of which implement AI) on top of Bluetooth low energy contact tracing, to keep record of human-to-human contacts, even when Bluetooth is not activated. The app can also make physical and mental health assessments, with user's consent, to predict possible causes of illness, by using cloud(Azure)-based healthcare chatbot, text-analytics and NLP service.

Video link for short demo: https://youtu.be/za8qsJncbUw

Long demo link: https://youtu.be/X13k4GPePLo

Google drive link for full resolution pictures: https://drive.google.com/drive/folders/1Hfn0mpAozTuFT7BC10Q-0TcQInDwpVDJ?usp=sharing

Google drive link for in-depth description:
https://docs.google.com/presentation/d/1u7hhSGgKJzNaJ2VDuBkLJaiZnG9WL11f/edit?usp=sharing&ouid=104042064728424758020&rtpof=true&sd=true

Webpage for carrying user to healthcare bot: https://github.com/kamsur/LazarusWeb

Azure function: https://github.com/kamsur/BarqatFunctions (python based)

Azure function: https://github.com/kamsur/FunctionsJava (Java based)

Tools used:
1. BLE plugin for Flutter (customized for this use case)
2. Azure Cognitive services (for NLP and text-analytics)
3. Azure AD B2C (for user authentication)
4. RESTful APIs
5. Microsoft Healthcare Bot
6. Google Cloud Firestore
7. QR code scanner and generator plugin for Flutter
8. Sqflite plugin for Flutter
