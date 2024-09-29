import { Component, inject } from '@angular/core';
import { InventoryTableComponent } from '../components/inventory-table/inventory-table.component';
import {
  IInventoryItem,
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
  sortBy = InventorySortBy.Weight;
  total = 0;
  page = 1;
  pageSize = 20;

  private inventoryService = inject(InventoryService);

  ngOnInit(): void {
    this.fetchInventories();
  }

  fetchInventories() {
    this.inventoryService
      .getInventories(this.page, this.pageSize, this.sortBy)
      .subscribe(({ items, meta: { total_count } }) => {
        this.inventories = items;
        this.total = total_count;
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
