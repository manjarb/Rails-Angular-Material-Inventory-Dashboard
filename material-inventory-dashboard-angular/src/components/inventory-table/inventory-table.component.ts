import {
  Component,
  effect,
  input,
  output,
} from '@angular/core';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { CommonModule } from '@angular/common';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import {
  MatButtonToggleChange,
  MatButtonToggleModule,
} from '@angular/material/button-toggle';
import { IInventoryItem, IInventorySummary, InventorySortBy } from '../../interfaces/inventory.interface';

@Component({
  selector: 'app-inventory-table',
  standalone: true,
  imports: [
    MatTableModule,
    MatPaginatorModule,
    CommonModule,
    MatButtonToggleModule,
  ],
  templateUrl: './inventory-table.component.html',
  styleUrl: './inventory-table.component.scss',
})
export class InventoryTableComponent {
  items = input<IInventoryItem[]>([]);
  total = input.required<number>();
  page = input.required<number>();
  pageSize = input.required<number>();
  sortBy = input<string>(InventorySortBy.Weight);
  summary = input<IInventorySummary>({
    totalItems: 0,
    totalVolume: '0',
  });
  handlePageChange = output<number>();
  handleSortByChange = output<InventorySortBy>();
  sortByValue = InventorySortBy;

  dataSource = new MatTableDataSource<IInventoryItem>();

  // Define the columns to be displayed in the table
  displayedColumns: string[] = [
    'productNumber',
    'formChoice',
    'gradeSurface',
    'finish',
    'dimensions',
    'quantity',
    'weight',
    'location',
  ];

  constructor() {
    effect(() => {
      this.dataSource.data = this.items();
    });
  }

  onPageChange(event: PageEvent) {
    this.handlePageChange.emit(event.pageIndex + 1);
  }

  onSortValueChange(event: MatButtonToggleChange) {
    this.handleSortByChange.emit(event.value);
  }

  formatDimensions(item: IInventoryItem): string {
    const dimensions = [];
    if (item.length != null) dimensions.push(`L=${item.length}`);
    if (item.width != null) dimensions.push(`W=${item.width}`);
    if (item.height != null) dimensions.push(`H=${item.height}`);
    if (item.thickness != null) dimensions.push(`T=${item.thickness}`);
    if (item.outerDiameter != null) dimensions.push(`OD=${item.outerDiameter}`);
    if (item.wallThickness != null) dimensions.push(`Wt=${item.wallThickness}`);
    if (item.webThickness != null) dimensions.push(`Tw=${item.webThickness}`);
    if (item.flangeThickness != null)
      dimensions.push(`Tf=${item.flangeThickness}`);

    return dimensions.join(', ');
  }
}
