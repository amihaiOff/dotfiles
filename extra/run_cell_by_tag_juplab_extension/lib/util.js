export function getTags(sender) {
    const cells = sender.cells;
    const tags = [];
    const set = new Set();
    for (let i = 0; cells && i <= cells.length; i += 1) {
        const cell = cells.get(i);
        if (cell) {
            const currentTags = cell.metadata.get('tags');
            if (currentTags) {
                for (const e of currentTags.toString().split(',')) {
                    set.add(e);
                }
            }
        }
    }
    for (const ele of set) {
        tags.push(ele);
    }
    return tags;
}
