const rl = @cImport(@cInclude("raylib.h"));
const std = @import("std");
const Arraylist = std.ArrayList;
const Layout = @import("./layout.zig").Layout;
const Grid = @import("./grid.zig").Grid;


pub const Composite = struct {
    width: c_int,
    height: c_int,
    x: c_int,
    y: c_int,
    layouts: Arraylist(Layout),
    grid: Grid,

    pub fn introduce(height: c_int, width: c_int, x: c_int, y: c_int) Composite {
        
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        var arena = std.heap.ArenaAllocator.init(gpa.allocator());
        defer arena.deinit();

        return Composite {
            .width = width, 
            .height = height, 
            .x = x, 
            .y = y, 
            .layouts = Arraylist(Layout).init(gpa.backing_allocator), 
            .grid = undefined 
        };
    }

    pub fn contain(self: *Composite, layout: Layout) anyerror!Layout {
        layout.drawRect();
        try self.layouts.append(layout);
        return layout;
    }

    pub fn setGridSystem(self: *Composite, cells: c_int) void {
        self.grid = Grid.introduce(cells, @floatFromInt(self.height), @floatFromInt(self.width));
    }

    pub fn griddedWidth(self: Composite, cells: c_int) c_int {
        if (self.grid.columns < cells) unreachable;
        return (cells * @as(c_int, @intFromFloat(self.grid.cellWidth)));
    }

    pub fn griddedHeight(self: Composite, cells: c_int) c_int {
        if (self.grid.rows < cells) unreachable;
        return (cells * @as(c_int, @intFromFloat(self.grid.cellHeight)));
    }


    pub fn conclude(self: Composite) void {
        for (0..self.layouts.items.len) |i| {
            self.layouts.items[i].conclude();
        }
        self.layouts.deinit();
    }







};