import { IPaginationData, IResponse } from "./general.interface";

export interface IInventoryItem {
  productNumber: string; // Always treated as a string
  form: string;
  choice: string;
  formChoice: string; // Concatenated `form` and `choice`
  grade: string;
  surface?: string | null; // Can be string or null
  finish: string;
  length?: number | null; // Can be number or null
  width?: number | null; // Can be number or null
  height?: number | null; // Can be number or null
  thickness?: number | null; // Can be number or null
  outerDiameter?: number | null; // Can be number or null
  wallThickness?: number | null; // Can be number or null
  webThickness?: number | null; // Can be number or null
  flangeThickness?: number | null; // Can be number or null
  quantity: number; // Assuming it's always a number
  weight: number; // Weight as a number
  location: string;
}

export interface IInventoryItemResponse {
  product_number: string;
  form: string;
  choice: string;
  form_choice: string;
  grade: string;
  surface: string | null;
  finish: string;
  length: number | null;
  width: string;
  height: string;
  thickness: number | null;
  outer_diameter: number | null;
  wall_thickness: string;
  web_thickness: number | null;
  flange_thickness: number | null;
  quantity: number;
  weight: number;
  location: string;
}


export interface IInventoryItemPaginationResponse
  extends IPaginationData<IInventoryItemResponse> {}

export interface IInventoryItemPaginationData
  extends IPaginationData<IInventoryItem> {}

export enum InventorySortBy {
  Weight = 'weight',
  FormChoice = 'form_choice',
}
