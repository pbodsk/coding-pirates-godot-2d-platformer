function Pandoc(doc)
    local blocks = {}

    table.insert(blocks, pandoc.RawBlock("html", '<article class="markdown-body">'))

    for _, block in ipairs(doc.blocks) do
        table.insert(blocks, block)
    end

    table.insert(blocks, pandoc.RawBlock("html", '</article>'))
    return pandoc.Pandoc(blocks, doc.meta)
end