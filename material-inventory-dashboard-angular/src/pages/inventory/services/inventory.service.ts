import { inject, Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { map, Observable } from 'rxjs';

import { environment } from '../../../environments/environment';
import { IInventoryItem, IInventoryItemPaginationData, IInventoryItemPaginationResponse, IInventoryItemResponse, IInventorySummary, IInventorySummaryResponse, InventorySortBy } from '../../../interfaces/inventory.interface';
import { IResponse } from '../../../interfaces/general.interface';

@Injectable({
  providedIn: 'root',
})
export class InventoryService {
  private apiUrl = `${environment.apiUrl}/api/v1/inventories`;

  private http = inject(HttpClient);

  getSummary(): Observable<IInventorySummary> {
    return this.http
      .get<IResponse<IInventorySummaryResponse>>(`${this.apiUrl}/summary`)
      .pipe(
        map((response) => ({
          totalItems: response.data.total_line_items,
          totalVolume: response.data.total_volume_tons,
        }))
      );
  }

  getInventories(
    page = 1,
    limit = 20,
    sortBy = InventorySortBy.Weight
  ): Observable<IInventoryItemPaginationData> {
    let fullUrl = `${this.apiUrl}?page=${page}&limit=${limit}&sort_column=${sortBy}`;

    if (sortBy === InventorySortBy.FormChoice) {
      fullUrl += '&sort_direction=asc';
    }

    return this.http
      .get<IResponse<IInventoryItemPaginationResponse>>(fullUrl)
      .pipe(
        map((response) => ({
          items: response.data.items.map((item) =>
            this.mapToInventoryItem(item)
          ),
          meta: response.data.meta,
        }))
      );
  }

  mapToInventoryItem(item: IInventoryItemResponse): IInventoryItem {
    return {
      productNumber: item.product_number,
      form: item.form || '',
      choice: item.choice || '',
      formChoice: item.form_choice || '',
      grade: item.grade || '',
      surface: item.surface ?? null, // Handle potential `null` values
      finish: item.finish || '',
      length: this.parseNumber(item.length),
      width: this.parseNumber(item.width),
      height: this.parseNumber(item.height),
      thickness: this.parseNumber(item.thickness),
      outerDiameter: this.parseNumber(item.outer_diameter),
      wallThickness: this.parseNumber(item.wall_thickness),
      webThickness: this.parseNumber(item.web_thickness),
      flangeThickness: this.parseNumber(item.flange_thickness),
      quantity: Number(item.quantity) || 0, // Assuming quantity should be a number
      weight: Number(item.weight) || 0, // Weight as a number
      location: item.location || '',
      material: item.material
    };
  }

  // Helper method to parse numeric values safely
  private parseNumber(value: any): number | null {
    return value !== null && value !== '' ? Number(value) : null;
  }
}
