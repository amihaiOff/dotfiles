/// <reference types="react" />
import { ReactWidget } from '@jupyterlab/apputils';
import { INotebookModel } from '@jupyterlab/notebook';
export interface IRunTagState {
    tags: string[];
}
export interface IRunTagProps {
    model: INotebookModel;
}
/**
 * A RunTagCell Lumino Widget that wraps a RunTagCellComponent.
 */
export declare class RunTagCellWidget extends ReactWidget {
    /**
     * Constructs a new RunTagCellWidget.
     */
    private _model;
    constructor(model: INotebookModel);
    render(): JSX.Element;
}
