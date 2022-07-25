import { ReactWidget } from '@jupyterlab/apputils';
import React from 'react';
import { getTags } from './util';
/**
 * React component for a counter.
 *
 * @returns The React component
 */
class RunTagCell extends React.Component {
    constructor(props) {
        super(props);
        this.state = { tags: ['no tags'] };
    }
    render() {
        const tagOptions = [];
        for (let i = 0; i < this.state.tags.length; i++) {
            tagOptions.push(React.createElement("option", { key: i, value: this.state.tags[i] }, this.state.tags[i]));
        }
        return React.createElement("select", null, tagOptions);
    }
    componentDidMount() {
        const { model } = this.props;
        model.contentChanged.connect((sender, args) => {
            let notebookTags = getTags(sender);
            if (notebookTags.length === 0) {
                notebookTags = ['no tags'];
            }
            this.setState({ tags: notebookTags });
        });
    }
}
/**
 * A RunTagCell Lumino Widget that wraps a RunTagCellComponent.
 */
export class RunTagCellWidget extends ReactWidget {
    constructor(model) {
        super();
        this._model = model;
        this.addClass('jp-Notebook-toolbarCellType');
        this.addClass('jp-Notebook-toolbarCellTypeDropdown');
        this.addClass('jp-HTMLSelect');
        this.addClass('jp-ReactWidget');
    }
    render() {
        return React.createElement(RunTagCell, { model: this._model });
    }
}
