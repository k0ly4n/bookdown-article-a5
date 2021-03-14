--[[
    Адаптация фильтра для задания стилей заголовков и обычных ячеек таблицы.
    Автор адаптации: Стрелков Н.О., <StrelkovNO@mpei.ru>

    Первоначальная версия этого фильтра доступна по ссылке ниже:
    https://github.com/pandocker/pandocker-lua-filters/blob/master/lua/docx-apply-cell-styles.lua
]]--

local table_cell_header_style = "TableCellHeader"; -- стиль заголовочный ячеек таблиц (первая строка)
local table_cell_body_style = "TableCellBody"; -- стиль остальных ячеек таблиц

    --[[
    # docx-apply-cell-styles.lua

    Finds table; get list of alignment; get list of styles to apply; apply styles for each cell
    ]]
    local stringify = require("pandoc.utils").stringify

    if FORMAT == "docx" then

            local function plain2para(el)
            if el.tag == "Plain" then
                el = pandoc.Para(el.content)
            end
            return el
        end

        local function get_aligns(el)
            local aligns = {}
            if (PANDOC_VERSION[1] >= 2) and (PANDOC_VERSION[2] < 10) then
                aligns = el.aligns
            else
                for _, v in ipairs(el.colspecs) do
                    table.insert(aligns, v[1])
                end
            end
            return aligns
        end

        local function get_headers(el)
            local headers = {}
            if (PANDOC_VERSION[1] >= 2) and (PANDOC_VERSION[2] < 10) then
                headers = el.headers
                return headers
            else
                headers = el.head
                return headers
            end
        end

        local function get_body_rows(el)
            local rows = {}
            if (PANDOC_VERSION[1] >= 2) and (PANDOC_VERSION[2] < 10) then
                rows = el.rows
                return rows
            else
                rows = el.bodies[1].body
                return rows
            end
        end

        local function apply_rows_styles(rows, styles)
            local row_attr = {}
            local _cell = {}

            for i, row in ipairs(rows) do
                row_attr = row[1]
                row = row[2]
                for j, cell in ipairs(row) do
                    _cell = pandoc.Div(cell.contents)
                    _cell["attr"]["attributes"]["custom-style"] = stringify(styles[j])
                    cell.contents = { _cell }
                    row[j] = cell
                end
                rows[i] = { row_attr, row }
            end
            return rows
        end

        local function apply_header_styles(header, styles)
            local header_attr = header[1]
            header = apply_rows_styles(header[2], styles)
            return { header_attr, header }
        end

        local function apply_cell_styles(el)

            el = pandoc.walk_block(el, { Plain = plain2para })
            local aligns = get_aligns(el)
            local headers = get_headers(el)
            local rows = get_body_rows(el)

            local body_styles = {}
            local header_styles = {}
            for _, v in ipairs(aligns) do
                table.insert(header_styles, table_cell_header_style)
                table.insert(body_styles, table_cell_body_style)
            end

            if (PANDOC_VERSION[1] >= 2) and (PANDOC_VERSION[2] < 10) then
                for i, header in ipairs(headers) do
                    --header = plain2para(header)
                    if #header > 0 then
                        local header_cell = pandoc.Div(header)
                        header_cell["attr"]["attributes"]["custom-style"] = stringify(header_styles[i])
                        el.headers[i] = { header_cell }

                    end

                end

                for i, row in ipairs(rows) do
                    for j, cell in ipairs(row) do
                        --cell = plain2para(cell)
                        local body_cell = pandoc.Div(cell)
                        body_cell["attr"]["attributes"]["custom-style"] = stringify(body_styles[j])
                        el.rows[i][j] = { body_cell }
                    end
                end
            else
                el.head = apply_header_styles(headers, header_styles)
                rows = apply_rows_styles(rows, body_styles)
            end
            return el
        end

        return { { Table = apply_cell_styles } }

    end
