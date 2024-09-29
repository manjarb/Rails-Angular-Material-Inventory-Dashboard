import { CommonModule } from '@angular/common';
import { Component, effect, inject, input, output } from '@angular/core';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { IInventoryItem } from '../../interfaces/inventory.interface';
import { InventoryService } from '../../pages/inventory/services/inventory.service';

@Component({
  selector: 'app-preference-match-table',
  standalone: true,
  imports: [MatTableModule, MatPaginatorModule, CommonModule],
  templateUrl: './preference-match-table.component.html',
  styleUrl: './preference-match-table.component.scss',
})
export class PreferenceMatchTableComponent {
  items = input<IInventoryItem[]>([]);
  total = input.required<number>();
  page = input.required<number>();
  pageSize = input.required<number>();
  handlePageChange = output<number>();

  dataSource = new MatTableDataSource<IInventoryItem>();

  // Define the columns to be displayed in the table
  displayedColumns: string[] = [
    'material',
    'form',
    'choice',
    'grade',
    'dimensions',
  ];

  private inventoryService = inject(InventoryService);
  formatDimensions = this.inventoryService.formatDimensions;

  constructor() {
    effect(() => {
      this.dataSource.data = this.items();
    });
  }

  onPageChange(event: PageEvent) {
    this.handlePageChange.emit(event.pageIndex + 1);
  }
}
