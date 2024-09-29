import { Component } from '@angular/core';
import { PreferenceUploadFormComponent } from '../components/preference-upload-form/preference-upload-form.component';

@Component({
  selector: 'app-preference-matches',
  standalone: true,
  imports: [PreferenceUploadFormComponent],
  templateUrl: './preference-matches.component.html',
  styleUrl: './preference-matches.component.scss',
})
export class PreferenceMatchesComponent {}
