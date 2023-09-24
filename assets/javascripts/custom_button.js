console.log("Custom button JavaScript loaded successfully!");
// Проверяем, что текущая страница - страница задачи
if (window.location.href.match(/\/issues\/\d+/)) {
    $(document).ready(function () {
        $("#content > .contextual").each(function () {
            var watchButton = $(this).find(".icon-edit");
            if (watchButton.length > 0) {
                //var issueId = parseInt($("#issue_id").val()); // Получаем ID задачи
                //var userId = <%= User.current.id %>; // Получаем ID текущего пользователя

                // Создаем кнопку-ссылку с текстом и иконкой
                var customButtonHtml = '<a href="#" id="custom_button" class="icon icon-unread" data-issue-id="' + issueId + '" data-user-id="' + CurrentUserId + '">Не прочитана</a>';
                watchButton.before(customButtonHtml);

                // Добавляем обработчик события для кнопки
                $("#custom_button").click(function (e) {
                    e.preventDefault(); // Предотвращаем переход по ссылке

                    //var issueId = $(this).data("issue-id");
                    //var userId = $(this).data("user-id");

                    // Выполняем AJAX-запрос для удаления записи
                    $.ajax({
                        url: "/issue_reads",
                        type: "DELETE",
                        data: { issue_id: issueId, user_id: CurrentUserId },
                        dataType: "json",
                        success: function (data) {
                            if (data.success) {
                                // Успешное удаление записи
                                alert("Задача помечена как непрочитанная");
                            } else {
                                // Ошибка при удалении
                                alert("Задача уже помечена как непрочитанная");
                            }
                        },
                        error: function () {
                            // Ошибка при выполнении запроса
                            alert("Произошла ошибка при отправке запроса");
                        },
                    });
                });

                return false; // Прекратить итерацию, если кнопка была найдена
            }
        });
    });
}
