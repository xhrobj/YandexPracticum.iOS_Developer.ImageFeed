## **Image Feed**

Многостраничное приложение предназначено для просмотра изображений через API Unsplash.

Цели приложения:
- Просмотр бесконечной ленты картинок из Unsplash Editorial.
- Просмотр краткой информации из профиля пользователя.

## **Ссылки**

[Дизайн в Figma](https://www.figma.com/file/HyDfKh5UVPOhPZIhBqIm3q/Image-Feed-(YP)?type=design&node-id=334-4892&mode=design&t=hV7ThmC01hcgjD79-0)
[Unsplash API](https://unsplash.com/documentation)

---

## Порядок сдачи домашнего задания:

1. Выполните задачу в Xcode.
2. Залейте готовую задачу на GitHub в отдельную ветку с названием sprint_XX. Важно:
- проект должен быть открытым!
- проект нужно выгрузить исходным кодом, то есть папкой со всеми файлами. Не надо загружать zip-архив — ревьюер не сможет его проверить!
3. Создайте Pull Request (ПР) и скопируйте ссылку на него. Вставьте её в специальную форму на сайте Практикума через кнопку «Сдать работу».

---

## Сдаём задачу спринта 8 на ревью (ветка sprint_08)

Вы завершили 8-й спринт и выполнили первые задачи по новому проекту Image Feed. Пришло время для ревью!
Вам нужно сдать проект, в котором есть:
- Свёрстан экран Launch Screen.
- Добавлен и свёрстан по макетам экран ленты изображений.

## Убедитесь, что:

1. Создан новый проект, в котором:
- iOS 13.0 указана как минимально поддерживаемая версия;
- в настройках основного таргета отключена сборка на iPad;
- проставлена только галочка поддержки портретной ориентации (в секции Device Orientation), а в Info удалены соответствующие значения для Supported interface orientations (iPhone);
- структура файлов совпадает со структурой, которую мы рассмотрели в теме «Инициализация второго проекта»;
- для проекта подключён Git — в меню Source Control в Xcode вам будут доступны меню управления репозиторием.
2. Свёрстан Launch Screen приложения:
- экран должен полностью соответствовать макету
3. Свёрстан главный экран с лентой изображений со следующими параметрами:
- лента содержит 20 фотографий;
- между фото есть отступ;
- края фотографий скруглены;
- на фото добавлен лейбл с текущей датой;
- на фото добавлена кнопка лайка;
- лайк проставлен у ячеек с чётным индексом и не проставлен — у нечётным;
- размеры, параметры и отступы элементов соответствуют макетам;
- высота ячейки зависит от размеров фото и является динамической.
4. Приложение запускается.
5. Элементы интерфейса адаптируются под разрешения экранов iPhone (вёрстка под iPad не предусмотрена).

## Сдаём задачу спринта 9 на ревью (ветка sprint_09)

Вы завершили 9-й спринт. Пришло время для ревью!
Вам нужно сдать проект, в котором есть:
- Экран профиля пользователя, свёрстанный кодом.
- Кнопка «Поделиться» на экране приложения.

## Убедитесь, что:

1. Экран профиля пользователя свёрстан кодом:
- создан соответствующий класс ProfileViewController;
- создан новый UIViewController в Storyboard;
- на него добавлен UIImageView, три UILabel и один UIButton;
- констрейнты расставлены нужным образом;
- из Figma выгружены соответствующие ресурсы (картинка для профиля и картинка для кнопки логаута) и подставлены в нужные элементы в ProfileViewController.
2. Добавлен экран отдельного изображения SingleImageViewController
- При открытии изображения на весь экран пользователь видит растянутое изображение до границ экрана.
- Изображение выровнено по центру.
- Вы добавили ScrollView на экран SingleImageViewController и выставили ему констрейнты, равные нулю со всех сторон.
- Добавлен outlet для  ScrollView (и назван, соответственно, scrollView).
3. На экране SingleImageViewController реализована кнопка «Поделиться»:
- Размеры и кнопка иконки соответствуют макету.
- Кнопка расположена над ScrollView, а не внутри него.
- Реализован метод didTapShareButton, который вызывается при тапе на кнопку.
- Добавлена функциональность шеринга картинки.

## Сдаём задачу спринта 10 на ревью (ветка sprint_10)

Вы завершили 10-й спринт и реализовали авторизацию в нашем приложении. Пришло время для ревью!
Вам нужно сдать проект, в котором есть:
- Экран авторизации с логотипом приложения и кнопкой «Войти».
- Авторизация реализована с помощью OAuth2.0.

## Убедитесь, что:

1. Ваше приложение зарегистрировано на сайте Unsplash.
2. Экран авторизации содержит логотип приложения и кнопку «Войти».
3. Для входа в приложение пользователь авторизуется через OAuth2.0:
- При входе в приложение пользователь видит splash-screen.
- После загрузки приложения открывается экран с возможностью авторизации.
- При нажатии на кнопку «Войти» открывается браузер на странице авторизации Unsplash.
- При нажатии на кнопку Login, если авторизация в Unsplash прошла успешно, браузер закрывается и выполняется POST-запрос для получения Auth Token.
- Если POST-запрос завершается успешно — экран авторизации скрывается, а в приложении открывается экран с лентой.
4. В проекте создан файл Constants.swift, в нём есть константы accessKey, secretKey, redirectURI и accessScope:
- Константы описаны внутри перечисления Constants статическими константами.
- В этих константах сохранены Access key, Secret key и Redirect URI вашего приложения.
- accessScope — список доступов, разделённых плюсом.
- Также добавлена константа defaultBaseURL — в неё сохранён базовый адрес API из документации. Эта константа должна быть типа URL.
5. Свёрстан контроллер WebView, его дизайн соответствует ТЗ.
6. Реализован KVO — приложение показывает, как обновляется прогресс загрузки веб-страницы.
7. Проверка необходимости авторизации выделена в отдельный контроллер SplashViewController:
- Создан стартовый контроллер, который выполняет проверку, был ли ранее авторизован пользователь.
- Если есть сохранённые данные об авторизации, пользователя отправляют на флоу галереи, если нет — на флоу авторизации.
- При первом запуске приложения пользователь видит SplashViewController, а затем — форму авторизации.
- При повторном запуске после ранее успешной авторизации пользователь сразу после SplashViewController попадает в галерею.
8. Добавлена структура для декодинга JSON-ответа от POST-запроса авторизации Unsplash — OAuthTokenResponseBody
9. Создан новый класс OAuth2Service:
- В нём объявлена функция fetchAuthToken, которая получает code на вход и, используя его, делает POST-запрос.
- Функция fetchAuthToken вторым аргументом получает completion — блок, который нужно вызвать при разборе результатов HTTP-запроса.
- Аргумент completion возвращает Swift.Result<String, Error>, где success соответствует только ситуации, когда в ответе на запрос был получен положительный HTTP статус код (значение в диапазоне 200 — 299), а в теле ответа получен и декодирован авторизационный токен. При этом блок completion вызван на главном потоке (DispatchQueue.main).
- Класс — синглтон, то есть представляет глобальную точку доступа и запрещает создание других экземпляров.
- В классе AuthViewController, там, где объявлен метод делегата func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String), вызван fetchAuthToken.
- В случае успешного выполнения запроса Bearer Token токен сохранён в User Defaults с использованием класса OAuth2TokenStorage.
10. Добавлено логирование ошибок в консоль; распечатаны:
- ошибочные кейсы, при получении опциональных значений, таких как URLComponents, URL, URLRequest;
- сетевые ошибки при работе метода URLSession.shared.dataTask;
- ошибки, которые вернул сервис Unsplash (с кодом ответа >=300);
- ошибка, которую может выкинуть декодер при получении OAuthTokenResponseBody.
11. В проекте не используется implicit unwrap и другие force-операции. Использовано безопасное извлечение значений опционалов и применен do-catch для throwable-методов.