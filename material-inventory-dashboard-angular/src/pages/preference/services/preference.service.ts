import { inject, Injectable } from '@angular/core';
import { environment } from '../../../environments/environment';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { catchError, map, Observable, throwError } from 'rxjs';
import { IInventoryItemPaginationData, IInventoryItemPaginationResponse, IInventorySummary } from '../../../interfaces/inventory.interface';
import { IResponse } from '../../../interfaces/general.interface';
import { InventoryService } from '../../inventory/services/inventory.service';

@Injectable({
  providedIn: 'root',
})
export class PreferenceService {
  private apiUrl = `${environment.apiUrl}/api/v1/preferences`;

  private http = inject(HttpClient);
  private inventoryService = inject(InventoryService);

  matchPreferences(
    file: File,
    page = 1,
    limit = 20
  ): Observable<IInventoryItemPaginationData> {
    const formData = new FormData();
    formData.append('file', file);

    let fullUrl = `${this.apiUrl}/upload?page=${page}&limit=${limit}`;

    return this.http
      .post<IResponse<IInventoryItemPaginationResponse>>(fullUrl, formData)
      .pipe(
        map((response) => ({
          items: response.data.items.map((item) =>
            this.inventoryService.mapToInventoryItem(item)
          ),
          meta: response.data.meta,
        })),
        catchError(this.handleError)
      );
  }

  private handleError(error: HttpErrorResponse) {
    // Customize as necessary for your use case
    let errorMessage = 'An unknown error occurred!';
    if (error.error instanceof ErrorEvent) {
      // Client-side or network error
      errorMessage = `Error: ${error.error.message}`;
    } else {
      // Backend error
      errorMessage = `Server returned code: ${error.status}, error message is: ${error.message}`;
    }
    return throwError(() => new Error(errorMessage));
  }
}
