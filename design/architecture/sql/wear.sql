
-- Степень износа
CREATE TYPE wear_severity AS ENUM (
    'OK',           -- Норма
    'EARLY',        -- Ранняя стадия дефекта
    'DEVELOPED',    -- Развитый дефект
    'CRITICAL'      -- Критический износ
);

