import { CommonModule } from '@angular/common';
import { Component, inject, output } from '@angular/core';
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

  uploadForm: FormGroup = this.fb.group({
    file: [null],
  });
  handleSubmit = output<File>();

  onSubmit(): void {
    const fileControl = this.uploadForm.get('file')?.value as File | null;
    console.log(fileControl, ' :fileControl');
    if (fileControl) {
      this.handleSubmit.emit(fileControl);
    }
  }

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      const file = input.files[0];
      this.uploadForm.patchValue({ file }); // Update the form control value
    }
  }
}
