import { CommonModule } from '@angular/common';
import { Component, inject } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { PreferenceService } from '../../services/preference.service';
import {
  IInventoryItem,
  InventorySortBy,
} from '../../../../interfaces/inventory.interface';
import { IButtonToggleOption } from '../../../../interfaces/general.interface';
import { InventoryTableComponent } from '../../../../components/inventory-table/inventory-table.component';

@Component({
  selector: 'app-preference-upload-form',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    MatButtonModule,
    MatFormFieldModule,
    MatInputModule,
    InventoryTableComponent,
  ],
  templateUrl: './preference-upload-form.component.html',
  styleUrl: './preference-upload-form.component.scss',
})
export class PreferenceUploadFormComponent {
  private fb = inject(FormBuilder);
  private preferenceService = inject(PreferenceService);

  inventories: IInventoryItem[] = [];
  total = 0;
  page = 1;
  pageSize = 20;
  sortOptions: IButtonToggleOption<InventorySortBy>[] = [
    { label: 'Weight', value: InventorySortBy.Weight },
  ];

  uploadForm: FormGroup = this.fb.group({
    file: [null],
  });

  fileToUpload: File | null = null;

  onFileChange(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      this.fileToUpload = input.files[0];
      this.fetchMatches();
    }
  }

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

  onSubmit(): void {
    this.fetchMatches();
  }

  onPageChange(page: number) {
    this.page = page;
    this.fetchMatches();
  }
}
