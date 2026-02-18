-- Связь событий с пользователем
-- - Наличие данной связи как флаг относит событие к категории событий безопасности
-- - Связь должна быть 1 : 1 (одному событию всегда соответствует один пользователь)

CREATE TABLE security_event (
    user_id: INT,
    event_id: BIGINT,
    PRIMARY KEY (event_id, user_id)
);

CREATE INDEX idx_security_event_event
  ON security_event(event_id);

CREATE INDEX idx_security_event_user
  ON security_event(user_id);
