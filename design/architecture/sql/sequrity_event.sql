-- Связь событий с пользователем
-- - Наличие данной связи как флаг относит событие к категории событий безопасности
-- - Связь должна быть 1 : 1 (одному событию всегда соответствует один пользователь)

CREATE TABLE security_event (
    event_id BIGINT NOT NULL
        REFERENCES event(uid) ON DELETE CASCADE,
    user_id INT NOT NULL
        REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (event_id)
);
-- Индекс для производительности запросов по пользователю и удалению
CREATE INDEX idx_security_event_user
  ON security_event(user_id);
