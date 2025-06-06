import { NotebookActions, INotebookTracker } from '@jupyterlab/notebook';
import { RunTagCellWidget } from './run-tag-widget';
import { ToolbarButton } from '@jupyterlab/apputils';
/**
 * Initialization data for the run-tag-cells-jlab extension.
 */
const extension = {
    id: 'run-tag-cells-jlab',
    autoStart: true,
    requires: [INotebookTracker],
    activate: (app, tracker) => {
        function runTagCells(args) {
            const tag = args['tag'];
            const panel = tracker.currentWidget;
            const notebook = panel.content;
            const prevIndex = notebook.activeCellIndex;
            notebook.widgets.forEach((child, index) => {
                let cellTags = child.model.metadata.get('tags') || [];
                cellTags = cellTags.toString().split(',');
                if (cellTags.indexOf(tag) !== -1) {
                    notebook.select(child);
                    notebook.activeCellIndex = index;
                }
            });
            const { context, content } = panel;
            return NotebookActions.run(content, context.sessionContext).then(() => {
                notebook.activeCellIndex = prevIndex;
            });
        }
        tracker.currentChanged.connect(() => {
            const notebook = tracker.currentWidget;
            // If notebook is added
            if (notebook) {
                const tagWidget = new RunTagCellWidget(notebook.model);
                notebook.toolbar.insertItem(10, 'select-tag-cells', tagWidget);
                const button = new ToolbarButton({
                    className: 'runAllCellsButton',
                    label: 'Run Tag Cells',
                    onClick: () => {
                        const selectOption = tagWidget.node.getElementsByTagName('select')[0];
                        const currentTag = selectOption.options[selectOption.selectedIndex].value;
                        return runTagCells({ tag: currentTag });
                    },
                    tooltip: 'Run Tag Cells'
                });
                notebook.toolbar.insertItem(11, 'run-tag-cells', button);
            }
        });
    }
};
export default extension;
