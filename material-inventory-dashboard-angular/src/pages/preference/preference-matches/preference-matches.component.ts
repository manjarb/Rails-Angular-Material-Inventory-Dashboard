import { Component, inject } from '@angular/core';
import { PreferenceUploadFormComponent } from '../components/preference-upload-form/preference-upload-form.component';
import { PreferenceMatchTableComponent } from '../../../components/preference-match-table/preference-match-table.component';
import { IInventoryItem } from '../../../interfaces/inventory.interface';
import { PreferenceService } from '../services/preference.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-preference-matches',
  standalone: true,
  imports: [
    PreferenceUploadFormComponent,
    PreferenceMatchTableComponent,
    CommonModule,
  ],
  templateUrl: './preference-matches.component.html',
  styleUrl: './preference-matches.component.scss',
})
export class PreferenceMatchesComponent {
  inventories: IInventoryItem[] = [];
  total = 0;
  page = 1;
  pageSize = 20;
  fileToUpload: File | null = null;

  private preferenceService = inject(PreferenceService);

  fetchMatches() {
    if (this.fileToUpload) {
      this.preferenceService
        .matchPreferences(this.fileToUpload, this.page)
        .subscribe(({ items, meta: { total_count } }) => {
          this.inventories = items;
          this.total = total_count;
        });
    }
  }

  onSubmit(file: File): void {
    this.fileToUpload = file;
    this.fetchMatches();
  }

  onPageChange(page: number) {
    this.page = page;
    this.fetchMatches();
  }
}
