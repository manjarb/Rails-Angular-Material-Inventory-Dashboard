export interface IResponse<T> {
  data: T,
  timestamp: number
}

export interface IPaginationData<T> {
  items: T[];
  meta: {
    current_page: number;
    total_pages: number;
    total_count: number;
    limit: number;
    next_page: number | null;
    prev_page: number | null;
  };
}
