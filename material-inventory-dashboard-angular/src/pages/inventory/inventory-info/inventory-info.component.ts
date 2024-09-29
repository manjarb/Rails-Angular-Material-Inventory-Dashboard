import { Component, inject } from '@angular/core';
import { InventoryTableComponent } from '../components/inventory-table/inventory-table.component';
import {
  IInventoryItem,
  IInventorySummary,
  InventorySortBy,
} from '../../../interfaces/inventory.interface';
import { InventoryService } from '../services/inventory.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-inventory-info',
  standalone: true,
  imports: [InventoryTableComponent, CommonModule],
  templateUrl: './inventory-info.component.html',
  styleUrl: './inventory-info.component.scss',
})
export class InventoryInfoComponent {
  inventories: IInventoryItem[] = [];
  summary: IInventorySummary = {
    totalItems: 0,
    totalVolume: '0',
  };
  sortBy = InventorySortBy.Weight;
  total = 0;
  page = 1;
  pageSize = 20;

  private inventoryService = inject(InventoryService);

  ngOnInit(): void {
    this.fetchInventories();
    this.fetchSummary()
  }

  fetchInventories() {
    this.inventoryService
      .getInventories(this.page, this.pageSize, this.sortBy)
      .subscribe(({ items, meta: { total_count } }) => {
        this.inventories = items;
        this.total = total_count;
      });
  }

  fetchSummary() {
    this.inventoryService.getSummary().subscribe((summary) => {
      this.summary = summary;
    });
  }

  onPageChange(page: number) {
    this.page = page;
    this.fetchInventories();
  }

  onSortByChange(sortBy: InventorySortBy) {
    this.sortBy = sortBy;
    this.fetchInventories();
  }
}
